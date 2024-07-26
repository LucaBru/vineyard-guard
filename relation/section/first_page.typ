#let logo = "../images/unipd_logo.svg"

#set page(numbering: none)

#grid(
    columns: (auto),
    rows: (1fr, auto, 20pt),
    // Intestazione
    [
        #align(center, text(18pt, weight: "semibold", "Università degli Studi di Padova"))
        #v(1em)
        #align(center, text(14pt, weight: "light", smallcaps("Dipartimento di Matematica ''Tullio Levi-Civita''")))
        #v(1em)
        #align(center, text(12pt, weight: "light", smallcaps("Computer science")))
    ],
    // Corpo
    [
        // Logo
        #align(center, image(logo, width: 50%))
        #v(30pt)

        // Titolo
        #align(center, text(18pt, hyphenate: false, weight: "semibold", "Vineyard Guard"))
        #v(10pt)
        #align(center, text(12pt, weight: "light", 
        "Technical report about the development of the mobile application Vineyard Guard as project for the Mobile Programming and Multimedia course, Master Degree in Computer Science at University of Padua."))
        #v(40pt)

        #align(right, text(11pt, "Luca Brugnera"))
        #v(5pt)
        #align(right, text(11pt, "2122421"))
        #v(30pt)
    ],
    // Piè di pagina
    [
        // Anno accademico
        #line(length: 100%)
        #align(center, text(8pt, weight: 400, smallcaps("academicYear" + " " + "2023-2024")))
    ]

)