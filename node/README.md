# file-catalog-rest-api-test
Testing the REST API of the file_catalog for make benefit WIPAC

## Obtaining the testing code
Clone the file_catalog repository:

    git clone https://github.com/dsschult/file_catalog.git

Follow the instructions in the `README.md` file at the root of the
project to learn how to start an instance of the file_catalog service.

## System dependencies
In order to test the REST API of the File Catalog service, you will
need to have [Node.js](https://nodejs.org/en/download/) installed.

## Installing Node.js dependencies
Once Node.js is installed, it will need to obtain packages in order
to make the test software work. In the node directory:

    npm install

## Running the tests
Modify `config.cson` to point at an instance of the file_catalog
that you would like to test.

After that, run the tests with this command:

    cake rebuild
