/**
 *Submitted for verification at Etherscan.io on 2021-09-05
 */

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// ERC 721 implementation.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// String encoding libraries
import { strings } from "./libraries/Strings.sol";
import { Base64 } from "./libraries/Base64.sol";

contract Names is ERC721 {

    /// @dev Specify library usage.
    using strings for string;
    using strings for strings.slice;

    /// @dev Names and the number of names of the given type.
    string private constant firstNames =
        "Satoshi,Vitalik,Vlad,Adam,Ailmar,Darfin,Jhaan,Zabbas,Neldor,Gandor,Bellas,Daealla,Derek,Nym,Vesryn,Angor,Gogu,Malok,Rotnam,Chalia,Astra,Fabien,Orion,Quintus,Remus,Rorik,Sirius,Sybella,Azura,Dorath,Freya,Ophelia,Yvanna,Zeniya,James,Robert,John,Michael,William,David,Richard,Joseph,Thomas,Charles,Mary,Patricia,Jennifer,Linda,Elizabeth,Barbara,Susan,Jessica,Sarah,Karen,Dilibe,Eva,Matthew,Bolethe,Polycarp,Ambrogino,Jiri,Chukwuebuka,Chinonyelum,Mikael,Mira,Aniela,Samuel,Isak,Archibaldo,Chinyelu,Kerstin,Abigail,Olympia,Grace,Nahum,Elisabeth,Serge,Sugako,Patrick,Florus,Svatava,Ilona,Lachlan,Caspian,Filippa,Paulo,Darda,Linda,Gradasso,Carly,Jens,Betty,Ebony,Dennis,Martin Davorin,Laura,Jesper,Remy,Onyekachukwu,Jan,Dioscoro,Hilarij,Rosvita,Noah,Patrick,Mohammed,Chinwemma,Raff,Aron,Miguel,Dzemail,Gawel,Gustave,Efraim,Adelbert,Jody,Mackenzie,Victoria,Selam,Jenci,Ulrich,Chishou,Domonkos,Stanislaus,Fortinbras,George,Daniel,Annabelle,Shunichi,Bogdan,Anastazja,Marcus,Monica,Martin,Yuukou,Harriet,Geoffrey,Jonas,Dennis,Hana,Abdelhak,Ravil,Patrick,Karl,Eve,Csilla,Isabella,Radim,Thomas,Faina,Rasmus,Alma,Charles,Chad,Zefram,Hayden,Joseph,Andre,Irene,Molly,Cindy,Su,Stani,Ed,Janet,Cathy,Kyle,Zaki,Belle,Bella,Amou,Steven,Olgu,Eva,Ivan,Vllad,Helga,Anya,John,Rita,Evan,Jason,Donald,Tyler,Changpeng,Sam";
    uint256 private constant firstNamesLength = 186;

    string private constant lastNames =
        "Nakamoto,Buterin,Zamfir,Mintz,Ashbluff,Marblemaw,Bozzelli,Fellowes,Windward,Yarrow,Yearwood,Wixx,Humblecut,Dustfinger,Biddercombe,Kicklighter,Vespertine,October,Gannon,Collymore,Stoll,Adler,Huxley,Ledger,Hayes,Ford,Finnegan,Beckett,Zimmerman,Crassus,Hendrix,Lennon,Thatcher,St. James,Cromwell,Monroe,West,Langley,Cassidy,Lopez,Jenkins,Udobata,Valova,Gresham,Frederiksen,Vasiliev,Mancini,Danicek,Okwuoma,Chibugo,Broberg,Strozak,Borkowska,Araujo,Geisler,Hidalgo,Ibekwe,Schmidt,Leehy,Rodrigue,Hines,Izmaylov,Egede,Pinette,Hakugi,McLellan,Mailhot,Lelkova,Simon,Tjangamarra,Sandgreen,Nystrom,Kjeldsen,Goncalves,Sos,Hornblower,Pelletier,Donaldson,Jackson,Rojo,Ermakov,Stornik,Lothran,Gousse,Henrichon,Onwuka,Horak,Elizondo,Mikulanc,Skotnik,Berg,Nilsson,Berg,Enyinnaya,Hermanns,Holmberg,Oliveira,Kufersin,Kwiatkowski,Courtois,Piest,Sandheaver,Woods,Ives,Dias,Grizelj,Viragh,Blau,Kodou,Torma,Sorokina,Took-Took,Allen,Melo,Bunker,Kiyomizu,Donkervoort,Maciejewska,Steffensen,Solomina,Zidek,Gotou,Bryant,Quenneville,Karlsen,Thomsen,Havlikova,Feron,Bazhenov,Amsel,Enoksen,Schneider,Kiss,Woodd,Benes,Probst,Aliyeva,Fleischer,Plain,Hoskinson,Chad,Maki,Gandhi,Zhao,Wintermute,Cronje,Felten,Yellen,Wood,Zhu,Davis,K,Delphine,Thorne,Kulechov,Nigiri,Goldfeder,Ranth,Galt,Lincoln,Trump";
    uint256 private constant lastNamesLength = 161;

    string private constant suffixes =
        "the Great,Jr.,Sr.,the Ape,the Magnificent,the Impaler,the Able,the Ambitious,the Astrologer,the Bad,the Bastard,the Blessed,the Bloody,the Conqueror,the Cruel,the Damned,Dracula,the Drunkard,the Elder,the Eloquent,the Enlightened,the Fair,the Farmer,the Fat,the Fearless,the Fighter,the Comfy,the Couch,the Fortunate,the Generous,the Gentle,the Glorious,the Good,the God-Given,the God,the Grim,the Handsome,the Hammer,Hadrada,the Hidden,the Holy,the Hunter,the Illustrious,the Invincible,the Iron,the Just,the Kind,the Lame,the Last,the Lawgiver,the Learned,the Liberator,the Lion,the Mad,the Magnanimous,the Mighty,the Monk,the Mild,the Musician,the Navigator,the Nobel,the Old,the One-Eyed,the Outlaw,the Pale,the Peaceful,the Philosopher,the Pilgrim,the Pious,the Poet,the Proud,the Quiet,the Rash,the Red,the Reformer,the Saint,the Savior,the Seer,the Short,the Silent,the Simple,the Sorcerer,the Strong,the Tall,the Terrible,the Thunderbolt,the Trembling,the Tyrant,the Unlucky,the Unready,the Vain,the Virgin,the Warrior,the Weak,the Wicked,the Wise,the Young,the Cuck,the Chad,the NoCoiner,.eth,da gay,the Prophet,the Paper-Handed,the Diamond-Handed";
    uint256 private constant suffixesLength = 104;

    /// @dev Emitted when an NFT is minted.
    event NameMinted(address _to, uint tokenId, string name);

    constructor(
        string memory _name, 
        string memory _symbol
    ) 
        ERC721(_name, _symbol) 
    {}

    // =====    Public functions    =====

    /// @dev Returns the 'First Name' for a given tokenId
    function getFirstName(uint256 tokenId) public pure returns (string memory) {
        return pluck(tokenId, "FIRST_NAME", firstNames, firstNamesLength);
    }

    /// @dev Returns the 'Last Name' for a given tokenId
    function getLastName(uint256 tokenId) public pure returns (string memory) {
        return pluck(tokenId, "LAST_NAME", lastNames, lastNamesLength);
    }

    /// @dev Returns the 'Suffix' for a given tokenId
    function getSuffix(uint256 tokenId) public pure returns (string memory) {
        return pluck(tokenId, "SUFFIX", suffixes, suffixesLength);
    }

    /// @dev Returns the full name for a given tokenId.
    function getName(uint256 tokenId)
        public 
        pure
        returns (string memory) 
    {
        string[5] memory parts;

        parts[0] = getFirstName(tokenId);

        parts[1] = " ";

        parts[2] = getLastName(tokenId);

        parts[4] = getSuffix(tokenId);

        parts[3] = bytes(parts[4]).length > 0 ? " " : "";

        string memory fullName = string(
            abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4])
        );

        return fullName;
    }

    /// @dev Returns the URI for the NFT with id `tokenId`
    function tokenURI(uint256 tokenId) public pure override returns (string memory) {
        string[3] memory parts;

        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getName(tokenId);

        parts[2] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(parts[0], parts[1], parts[2])
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        parts[1],
                        '", "description": "LootName is randomized adventurer name generated on chain.  Feel free to use LootName in any way you want.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );

        output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    // =====    External functions    =====

    /// @dev Mints a name NFT with `nextTokenId` as the tokenId.
    function mintName(uint _tokenId) external {

        // Mint NFT
        _safeMint(_msgSender(), _tokenId);

        emit NameMinted(_msgSender(), _tokenId, getName(_tokenId));
    }

    // =====    Internal functions    =====

    /// @dev Returns a pseudo-random integer based on `input`
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    /// @dev Returns a single item from `sourceCSV`
    function pluck(
        uint256 tokenId,
        string memory keyPrefix,
        string memory sourceCSV,
        uint256 sourceCSVLength
    ) 
        internal 
        pure 
        returns (string memory) 
    {
        uint256 rand = random(
            string(abi.encodePacked(keyPrefix, Strings.toString(tokenId)))
        );
        return getItemFromCSV(sourceCSV, rand % sourceCSVLength);
    }

    /// @dev Returns a single item at `index` from csv `str`
    /// @param str - The entire comma separated string.
    /// @param index - the position in the comma separated string.
    ///                E.g. If `index` == 10, the returned item will be the 11th name in `str` (zero indexed).
    function getItemFromCSV(string memory str, uint256 index)
        internal
        pure
        returns (string memory)
    {

        strings.slice memory strSlice = str.toSlice();
        string memory separatorStr = ",";
        strings.slice memory separator = separatorStr.toSlice();
        strings.slice memory item;
        for (uint256 i = 0; i <= index; i++) {            
            item = strSlice.split(separator);
        }
        return item.toString();
    }
}