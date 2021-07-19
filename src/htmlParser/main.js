const HTMLParser = require("node-html-parser");
const fs = require("fs");

const outputFolderPath = "../generatedXML/";
const inputFolderPath = "../htmlSourceData/";
const states = ["germany", "france", "switzerland", "united-kingdom"];
const XMLDeclaration = '<?xml version="1.0" encoding="UTF-8"?>\n';
const XMLRootTagName = "state";

/**
 * read file
 * @param {string} fileName - file name
 * @returns {(string|undefined)} - content of file, if no error occures
 */
function readFile(fileName) {
	try {
		const fileContent = fs.readFileSync(fileName, "utf8");
		return fileContent;
	} catch (err) {
		console.error(err);
		return undefined;
	}
}

/**
 * writte data into file (append behind content of file)
 * @param {string} fileName - file name
 * @param {string} data - data, which will be appended into file
 * @return {boolean} - if appending was successful or not
 */
async function appendToFile(fileName, data) {
	await fs.promises.appendFile(fileName, data, function (err) {
		if (err) throw err;
	});
}

/**
 * select all main sections and return array of ids of this sections
 * (id is section name in lowercase and spaces are replaced by '-')
 * @param {HTMLElement} root
 * @returns {Array} - of ids
 */
function extractMainSectionsIds(root) {
	return root
		.querySelectorAll("h2") //get all h2 elelents
		.map((item) => item.text.toLowerCase().replace(/ /g, "-")) //turn them into strings, replace spaces, to lowercase
		.filter((item) => !item.includes("photos")); //delete photots, not interested in this section
}

/**
 * replace special characters, which are not allowed in xml by their escape sequences
 * @param {string} data
 * @returns {string}
 */
function escapeSpecialCharacters(data) {
	return data
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/&/g, "&amp;")
		.replace(/'/g, "&apos;")
		.replace(/"/g, "&quot;");
}

/**
 * parse html section into xml representation
 * @param {string} sectionId - id of section int html document
 * @param {HTMLElement} root - parsed html document
 * @returns {string} parsed section in XML format
 */
function returnSectionInXML(sectionId, root) {
	let sectionXML = `\t<section heading="${escapeSpecialCharacters(
		sectionId.replace(/-/g, " ")
	)}">\n`;

	const sectionElement = root.querySelector(`#${sectionId}`);

	const subSectionElements = sectionElement.querySelectorAll("div");

	//loop through all subsections
	for (const subSection of subSectionElements) {
		const subsectionHeading = subSection.querySelector("h3");
		const subsectionParagraphs = subSection.querySelectorAll("p");

		//subsection heading corrupted or not exists => go to the next
		if (!subsectionHeading) continue;

		//subsection start
		sectionXML += `\t\t<subsection heading="${escapeSpecialCharacters(
			subsectionHeading.text.replace(/\s+/g, " ").trim()
		)}">\n`;

		//subsection paragraps is not null
		if (subsectionParagraphs) {
			let someParagraphNotEmpty = false;

			//loop through all paragraphs
			for (paragraph of subsectionParagraphs) {
				//add subsection paragraph
				if (paragraph) {
					let paragraphText = escapeSpecialCharacters(
						paragraph.text.replace(/\s+/g, " ").trim()
					);

					//paragraphs is empty
					if (!paragraphText) {
						continue;
					}

					//beginning tag
					let subsectionparagraph = "\t\t\t<subsectionparagraph>";

					//if paragraph html contein strong, but not start by strong take only its text
					if (
						paragraph.innerHTML.match(/<strong>/g) !== null &&
						!paragraph.innerHTML.startsWith("<strong>")
					) {
						sectionXML += `\t\t\t<subsectionparagraph>\n\t\t\t\t<field>\n\t\t\t\t\t<data>${paragraph.text}</data>\n\t\t\t\t</field>\n\t\t\t</subsectionparagraph>\n\n`;
						someParagraphNotEmpty = true;
						continue;
					}

					//add innner html of paragraph
					subsectionparagraph += paragraph.innerHTML
						.replace(/\s+/g, " ") //squash white spaces (like tabs...)
						.trim() // trim useless white spaces at beginning and ending
						.replace(/<br><br><br>/g, " ") //delete triple new line
						.replace(/<strong>/g, "\n\t\t\t\t<field>\n\t\t\t\t\t<subject>") //add filed and subject subject beginning tag
						.replace(/<\/strong>/g, "</subject>\n\t\t\t\t\t<data>") //add subject ending and data beginning tag
						.replace(
							/<br><br>\n\t\t\t\t<field>/g,
							"</data>\n\t\t\t\t</field>\n\t\t\t\t<field>"
						) //add data ending tag
						.replace(
							/<\/data>\n\t\t\t\t<field>/g,
							"</data>\n\t\t\t\t</field>\n\t\t\t\t<field>"
						); //add field ending tag

					//append data ending tag if it is missing
					if (
						(subsectionparagraph.match(/<data>/g) || []).length !==
						(subsectionparagraph.match(/<\/data>/g) || []).length
					) {
						subsectionparagraph += "</data>";
					}

					//add field beginning tag if there arent't any (because there wasn't strong tag before)
					if ((subsectionparagraph.match(/<field>/g) || []).length === 0) {
						subsectionparagraph = subsectionparagraph.replace(
							/<subsectionparagraph>/g,
							"<subsectionparagraph>\n\t\t\t\t<field>\n\t\t\t\t\t<data>"
						);
					}

					//add data ending tag if it is missing
					if (
						(subsectionparagraph.match(/<data>/g) || []).length !==
						(subsectionparagraph.match(/<\/data>/g) || []).length
					) {
						subsectionparagraph += "</data>";
					}

					//add field ending tag if it is missing
					if (
						(subsectionparagraph.match(/<field>/g) || []).length !==
						(subsectionparagraph.match(/<\/field>/g) || []).length
					) {
						subsectionparagraph += "\n\t\t\t\t</field>";
					}

					//add subsection paragraph ending tag
					subsectionparagraph += "\n\t\t\t</subsectionparagraph>";

					//trim space before subject end tag
					subsectionparagraph = subsectionparagraph.replace(
						/: <\/subject>/g,
						":</subject>"
					);

					//replace </data></data> duplication
					subsectionparagraph = subsectionparagraph.replace(
						/<\/data><\/data>/g,
						"</data>"
					);

					//remove html ending tags inside paragraph
					subsectionparagraph = subsectionparagraph.replace(
						/<\/em>|<\/div>|<br>|<br\/>|<br \/>|<\/pre>|<\/span>|<\/img>|<\input>|<\label>|<\/select>|<\/code>|<\/p>|<\/abbr>|<\/a>|<\/cite>/g,
						""
					);

					//remove html beginning tags
					subsectionparagraph = subsectionparagraph.replace(
						/<em>|<em.*">|<div>|<div.*">|<pre.*">|<span>|<span.*">|<img.*">|<input>|<input.*">|<label>|<label.*">|<select>|<select.*'>|<code>|<code.*">|<p>|<p.*">|<abbr>|<abbr.*">|<a>|<a.*">|<cite>|<cite.*">/g,
						""
					);

					//remove entities
					subsectionparagraph = subsectionparagraph.replace(
						/&nbsp;|&rsquo;|&eacute;|&auml;|&Eacute;| & /g,
						""
					);

					//replace greater than and lower than by entity
					subsectionparagraph = subsectionparagraph.replace(/<([0-9])/g, "&lt;$1");
					subsectionparagraph = subsectionparagraph.replace(/^p>([0-9])/g, "&gt;$1");
					subsectionparagraph = subsectionparagraph.replace(/<(-)/g, "&gt;$1");
					subsectionparagraph = subsectionparagraph.replace(/^p>(-)/g, "&gt;$1");

					if ((subsectionparagraph.match(/<data><\/data>/g) || []).length === 0) {
						sectionXML += `${subsectionparagraph}\n\n`;
						someParagraphNotEmpty = true;

						// console.log(subsectionparagraph);
						// console.log("---------------------------------------");
					}
				}
			}
			//if all paragraphs were empty
			if (!someParagraphNotEmpty) {
				sectionXML += "\t\t\t<subsectionparagraph>none</subsectionparagraph>\n\n";
			}
		}

		//subsection end
		sectionXML += "\t\t</subsection>\n\n";
	}

	sectionXML += "\t</section>\n";

	return sectionXML;
}

/**
 * parse one state (HTML file) into one XML file
 * @param {string} state
 * @returns {boolean} - if parsing was successful or not
 */
async function createXMLFromHTML(state) {
	const outputFile = `${outputFolderPath}${state}.xml`;

	//read html
	let data = readFile(`${inputFolderPath}${state}.html`);
	if (!data) {
		console.log(`html data for ${state} not readed`);
		return false;
	}

	const root = HTMLParser.parse(data); //parse html
	const ids = extractMainSectionsIds(root); //extract main sections ids

	//try remove files if already exist, new file will be created
	try {
		fs.unlinkSync(outputFile);
	} catch (e) {}

	//output start of xml
	try {
		await appendToFile(outputFile, `${XMLDeclaration}<${XMLRootTagName} name="${state}">\n`);
	} catch (e) {
		console.log(e);
		return false;
	}

	//parse all sections and save them
	for (const i of ids) {
		try {
			await appendToFile(outputFile, `${returnSectionInXML(i, root)}\n`);
		} catch (e) {
			console.log(e);
			return false;
		}
	}

	//output end of xml
	try {
		await appendToFile(outputFile, `</${XMLRootTagName}>`);
	} catch (e) {
		console.log(e);
		return false;
	}
	return true;
}

/**
 * start of whole program, parse all states
 */
function main() {
	//create new output folder if it doesn't exist
	if (!fs.existsSync(outputFolderPath)) {
		fs.mkdirSync(outputFolderPath);
	}

	//parse all states
	for (const state of states) {
		try {
			fs.unlinkSync(outputFolderPath + state + ".xml"); //remove old file
		} catch (e) {} //no such a file, its ok

		if (createXMLFromHTML(state)) {
			console.log(`${state} parsing was scuccessful`);
		} else {
			console.log(`error occurres when parsing ${state}`);
		}
	}
}

//program start
main();
