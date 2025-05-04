create table meal (
    id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title varchar(50) NOT NULL,
    description TEXT,
    location varchar(100) Not null,
    `when` datetime, -- when without quotes = reserved word; when with '' ('when') = all of the names need to be in quotes; when in backticks = fine :)
    max_reservations int,
    price decimal(10,2),
    created_date datetime DEFAULT CURRENT_TIMESTAMP
);
