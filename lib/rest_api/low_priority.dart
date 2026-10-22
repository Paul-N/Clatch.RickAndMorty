/// Marks a request as low priority (images). The header is removed before the
/// request is sent. Requests without it (JSON) are high priority.
const requestPriorityHeader = 'x-request-priority';
const lowPriorityHeaders = {requestPriorityHeader: 'low'};