create table typeorm_metadata
(
    type     varchar not null,
    database varchar,
    schema   varchar,
    "table"  varchar,
    name     varchar,
    value    text
);

alter table typeorm_metadata
    owner to postgres;

create table coordinates
(
    id        varchar          not null
        constraint "PK_1c59319abc3dbf9c0e3d2ed9250"
            primary key,
    latitude  double precision not null,
    longitude double precision not null
);

alter table coordinates
    owner to postgres;

create table addresses
(
    id                 varchar                                                                           not null
        constraint "PK_745d8f43d3af10ab8247465e450"
            primary key,
    address_line_1     varchar(45)                                                                       not null,
    address_line_2     varchar(45)                                                                       not null,
    address_line_3     varchar(45)                                                                       not null,
    locality           varchar(45)                                                                       not null,
    landmark           varchar(45)                                                                       not null,
    city               varchar(45)                                                                       not null,
    state              varchar(45),
    country            varchar(45),
    "associatedEntity" addresses_associatedentity_enum default 'driver'::addresses_associatedentity_enum not null,
    pincode            varchar(45)                                                                       not null,
    coordinate_id      varchar
        constraint "FK_ceec6c4be41a6af2d54a0682fe7"
            references coordinates
);

alter table addresses
    owner to postgres;

create table "query-result-cache"
(
    id         serial
        constraint "PK_6a98f758d8bfd010e7e10ffd3d3"
            primary key,
    identifier varchar,
    time       bigint  not null,
    duration   integer not null,
    query      text    not null,
    result     text    not null
);

alter table "query-result-cache"
    owner to postgres;

create table operators
(
    id                 varchar                                                                           not null
        constraint "PK_3d02b3692836893720335a79d1b"
            primary key,
    first_name         varchar(45)                                                                       not null,
    last_name          varchar(45)                                                                       not null,
    registered_company varchar(45)                                                                       not null,
    company_name       varchar(45)                                                                       not null,
    gst_number         varchar(45)                                                                       not null,
    nationality        varchar(45)                                                                       not null,
    operation_type     operators_operation_type_enum default 'intra_city'::operators_operation_type_enum not null,
    number_of_drivers  integer                                                                           not null,
    number_of_vehicles integer                                                                           not null,
    address_id         varchar
        constraint "FK_8a3d75ca54eabd49e902baa9d87"
            references addresses
);

alter table operators
    owner to postgres;

create table carriers_on_platform
(
    id                         varchar                                                                                        not null
        constraint "PK_447dd10ca1733511260204bebbe"
            primary key,
    plate_number               varchar(45)                                                                                    not null,
    name                       varchar(45)                                                                                    not null,
    operate_on                 carriers_on_platform_operate_on_enum default 'roadway'::carriers_on_platform_operate_on_enum   not null,
    category                   carriers_on_platform_category_enum   default 'medium_duty'::carriers_on_platform_category_enum not null,
    type                       carriers_on_platform_type_enum       default 'flatbed'::carriers_on_platform_type_enum         not null,
    number_of_wheels           integer                                                                                        not null,
    fuel_type                  varchar(45)                                                                                    not null,
    number_of_container        integer                                                                                        not null,
    total_capacity             double precision                                                                               not null,
    manufacturer_company       varchar(45)                                                                                    not null,
    model_number               varchar(45)                                                                                    not null,
    launch_year                integer                                                                                        not null,
    manufacturing_discontinued integer                                                                                        not null,
    energy_consumption_per_km  double precision                                                                               not null,
    emission_co2_per_km        double precision                                                                               not null,
    operator_id                varchar
        constraint "FK_6dddf8f97ae29d6f976f53467bc"
            references operators
);

alter table carriers_on_platform
    owner to postgres;

create table consignments
(
    id                        varchar                                                                         not null
        constraint "PK_ac4a3e322938f3ea03ee389f7c3"
            primary key,
    date_added                timestamp                       default now()                                   not null,
    deliver_deadline_date     timestamp                       default now()                                   not null,
    goods_type                varchar(45)                                                                     not null,
    goods_quantity            integer                                                                         not null,
    special_handling          varchar(45)                                                                     not null,
    packaging_type            varchar(45)                                                                     not null,
    is_floor_only             boolean                                                                         not null,
    is_stackable              boolean                                                                         not null,
    is_rotatable              boolean                                                                         not null,
    rotation_type             consignments_rotation_type_enum default 'None'::consignments_rotation_type_enum not null,
    stack_type                consignments_stack_type_enum    default 'None'::consignments_stack_type_enum    not null,
    color                     varchar(45)                                                                     not null,
    pickup_time_window_start  timestamp                       default now()                                   not null,
    pickup_time_window_end    timestamp                       default now()                                   not null,
    dropoff_time_window_end   timestamp                       default now()                                   not null,
    dropoff_time_window_start timestamp                       default now()                                   not null,
    status                    varchar(45)                                                                     not null,
    pickup_timestamp          timestamp                       default now()                                   not null,
    delivered_timestamp       timestamp                       default now()                                   not null,
    pickup_coord_id           varchar
        constraint "REL_02c24eb6d6b871c6ba3c1e73f7"
            unique
        constraint "FK_02c24eb6d6b871c6ba3c1e73f79"
            references coordinates,
    dropoff_coord_id          varchar
        constraint "REL_ae9b2cde1b07b57ce91d16bf80"
            unique
        constraint "FK_ae9b2cde1b07b57ce91d16bf801"
            references coordinates,
    pickup_address_id         varchar
        constraint "REL_95cc13bf14cfe65a58c2c981bf"
            unique
        constraint "FK_95cc13bf14cfe65a58c2c981bf6"
            references addresses,
    dropoff_address_id        varchar
        constraint "REL_51b23dc2289ab4641be7103f9d"
            unique
        constraint "FK_51b23dc2289ab4641be7103f9d4"
            references addresses,
    operator_id               varchar
        constraint "FK_c95526ab650f3b8feb5bcd10b4f"
            references operators,
    shipment_charges          double precision                                                                not null,
    max_temp                  double precision                                                                not null,
    min_temp                  double precision                                                                not null,
    length                    double precision                                                                not null,
    width                     double precision                                                                not null,
    height                    double precision                                                                not null,
    weight                    double precision                                                                not null,
    stack_weight              double precision                                                                not null
);

alter table consignments
    owner to postgres;

create table carrier_live_locations
(
    id            varchar not null
        constraint "PK_3cee9b896eada56a77e85be4be7"
            primary key,
    fuel_level    integer not null,
    coordinate_id varchar
        constraint "FK_ece36b2d42f71e656ce82dadba3"
            references coordinates
);

alter table carrier_live_locations
    owner to postgres;

create table carrier_issues
(
    id                    varchar                                not null
        constraint "PK_eb39c64cc84c400fa4b4cec582a"
            primary key,
    timestamp             timestamp with time zone default now() not null,
    description_of_issue  varchar(200)                           not null,
    path_to_image         varchar(45)                            not null,
    issue_type            varchar(45)                            not null,
    date_issue_resolution timestamp                default now() not null,
    carrier_id            varchar
        constraint "FK_a35a5405fccbd54b8f546fe4367"
            references carriers_on_platform
);

alter table carrier_issues
    owner to postgres;

create table containers_on_platform
(
    id                      varchar                                                                                                                not null
        constraint "PK_c656c217234ecb0f5c8248ad785"
            primary key,
    roof                    containers_on_platform_roof_enum                    default 'Closed'::containers_on_platform_roof_enum                 not null,
    roof_material           varchar(45)                                                                                                            not null,
    type_of_cargo_supported containers_on_platform_type_of_cargo_supported_enum default 'Dry'::containers_on_platform_type_of_cargo_supported_enum not null,
    external_length         integer                                                                                                                not null,
    external_width          integer                                                                                                                not null,
    external_height         integer                                                                                                                not null,
    internal_length         integer                                                                                                                not null,
    internal_width          integer                                                                                                                not null,
    internal_height         integer                                                                                                                not null,
    overhang_length         integer                                                                                                                not null,
    overhang_width          integer                                                                                                                not null,
    overhang_height         integer                                                                                                                not null,
    material                varchar(45)                                                                                                            not null,
    tare_weight             integer                                                                                                                not null,
    tonnage                 integer                                                                                                                not null,
    container_description   varchar(45)                                                                                                            not null,
    operator_id             varchar
        constraint "FK_fcfe78a40312fbf920818b7fee3"
            references operators,
    carrier_id              varchar
        constraint "FK_ba7131c915a3cbee4604b816842"
            references carriers_on_platform
);

alter table containers_on_platform
    owner to postgres;

create table container_issues
(
    issue_type            varchar(45)             not null,
    timestamp             timestamp default now() not null,
    description_of_issue  varchar(200)            not null,
    path_to_image         varchar(45)             not null,
    date_issue_resolution timestamp default now() not null,
    container_id          varchar
        constraint "FK_e33ac337212c8391ba0dbb42822"
            references containers_on_platform,
    id                    varchar                 not null
        constraint "PK_657d2384fd6994ce31c688e861e"
            primary key
);

alter table container_issues
    owner to postgres;

create table routes_current
(
    id                       varchar                      not null
        constraint "PK_5f1896a1c2172d8be2aa4d7cc1a"
            primary key,
    list_of_coordinate_ids   text      default '[]'::text not null,
    time_of_route_generation timestamp default now()      not null,
    carrier_id               varchar
        constraint "FK_040d10e53cc46a1939aa859cd14"
            references carriers_on_platform
);

alter table routes_current
    owner to postgres;

create table depots_on_platform
(
    id             varchar     not null
        constraint "PK_e0aa9021350f4e062975bb42ad7"
            primary key,
    type           varchar(45) not null,
    contact_number varchar(45) not null,
    contact_email  varchar(45) not null,
    goods_type     varchar(45) not null,
    address_id     varchar
        constraint "FK_9e3799b68bbcff0c9f9da05da28"
            references addresses,
    coordinate_id  varchar
        constraint "FK_17125243d260661189947c33bf1"
            references coordinates
);

alter table depots_on_platform
    owner to postgres;

create table drivers_on_platform
(
    id                        varchar                                                                         not null
        constraint "PK_30e3e4e1d27f8f239238aa2e067"
            primary key,
    contact_number            varchar(45)                                                                     not null,
    name                      varchar(45)                                                                     not null,
    gender                    drivers_on_platform_gender_enum default 'Male'::drivers_on_platform_gender_enum not null,
    types_of_vehicle_drivable varchar(45)                                                                     not null,
    driver_license_id         varchar(45)                                                                     not null,
    nationality               varchar(45)                                                                     not null,
    driver_license_image_path varchar(45)                                                                     not null,
    operator_id               varchar
        constraint "FK_f5fb60d7f862d82ecbcf146eb72"
            references operators,
    address_id                varchar
        constraint "FK_cc457b887376d7da057540d6d2d"
            references addresses
);

alter table drivers_on_platform
    owner to postgres;

create table routes_history
(
    id                       varchar                      not null
        constraint "PK_00d4e5a3f353404fbb4ced91986"
            primary key,
    list_of_coordinate_ids   text      default '[]'::text not null,
    time_of_route_generation timestamp default now()      not null,
    carrier_id               varchar
        constraint "FK_56f81c5f6da987d5817e8a1e5fe"
            references carriers_on_platform
);

alter table routes_history
    owner to postgres;

create table consignment_movements
(
    id                varchar                                not null
        constraint "PK_338cdef0ecb93dcfeac2ffcfe19"
            primary key,
    sequence_hop      integer                                not null,
    status            integer                                not null,
    wall              integer                                not null,
    layer             integer                                not null,
    position_in_layer integer                                not null,
    start_timestamp   timestamp with time zone default now() not null,
    end_timestamp     timestamp with time zone default now() not null,
    container_id      varchar
        constraint "FK_bb86af79b5dd9e78a40b70fcef1"
            references containers_on_platform,
    start_coord_id    varchar
        constraint "FK_f18b00d4a858463d56c4fe6b4d5"
            references coordinates,
    end_coord_id      varchar
        constraint "FK_a7c51c7687b3b3d982b19c92868"
            references coordinates,
    start_address_id  varchar
        constraint "FK_82726426d5891fc7d89fb7e5e0c"
            references addresses,
    end_address_id    varchar
        constraint "FK_39ea641f377ca907191a1733108"
            references addresses,
    x                 integer                                not null,
    y                 integer                                not null,
    z                 integer                                not null
);

alter table consignment_movements
    owner to postgres;

