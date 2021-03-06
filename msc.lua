-- module containing modsecurity to be used

local ffi = require("ffi")

ffi.cdef[[

typedef struct ModSecurity ModSecurity;
ModSecurity* msc_init();
void msc_set_connector_info(ModSecurity *msc, const char *connector);
void msc_cleanup(ModSecurity *msc);

typedef struct Rules Rules;
Rules* msc_create_rules_set();
int msc_rules_add_file(Rules *rules, const char *file, const char **error);
int msc_rules_cleanup(Rules *rules);

typedef struct Transaction Transaction;
Transaction *msc_new_transaction(ModSecurity *ms, Rules *rules, void *logCbData);
int msc_process_connection(Transaction *transaction, const char *client, int cPort, const char *server, int sPort);
int msc_process_uri(Transaction *transaction, const char *uri, const char *protocol, const char *http_version);
int msc_add_request_header(Transaction *transaction, const unsigned char *key, const unsigned char *value);
int msc_process_request_headers(Transaction *transaction);
int msc_process_request_body(Transaction *transaction);
int msc_add_response_header(Transaction *transaction, const unsigned char *key, const unsigned char *value);
int msc_process_response_headers(Transaction *transaction, int code, const char* protocol);
int msc_process_response_body(Transaction *transaction);
int msc_process_logging(Transaction *transaction);
void msc_transaction_cleanup(Transaction *transaction);

typedef struct ModSecurityIntervention_t {
    int status;
    int pause;
    char *url;
    char *log;
    int disruptive;
} ModSecurityIntervention;
int msc_intervention(Transaction *transaction, ModSecurityIntervention *it);

]]

local msc = ffi.load("/usr/local/modsecurity/lib/libmodsecurity.so")

return msc
