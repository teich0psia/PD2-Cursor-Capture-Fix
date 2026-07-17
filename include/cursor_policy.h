#ifndef PD2CCF_CURSOR_POLICY_H
#define PD2CCF_CURSOR_POLICY_H

#include <stdbool.h>

typedef struct pd2ccf_rect {
    long left;
    long top;
    long right;
    long bottom;
} pd2ccf_rect;

typedef enum pd2ccf_release_action {
    PD2CCF_RELEASE_NONE = 0,
    PD2CCF_RELEASE_CALL,
    PD2CCF_RELEASE_DROP_OWNERSHIP,
    PD2CCF_RELEASE_RETRY
} pd2ccf_release_action;

bool pd2ccf_rect_equal(const pd2ccf_rect *a, const pd2ccf_rect *b);
bool pd2ccf_should_apply(bool active, bool desired_valid, const pd2ccf_rect *desired,
                         bool current_valid, const pd2ccf_rect *current);
pd2ccf_release_action pd2ccf_choose_release(bool owns_clip, bool last_valid,
                                             const pd2ccf_rect *last,
                                             bool current_valid,
                                             const pd2ccf_rect *current);

#endif
