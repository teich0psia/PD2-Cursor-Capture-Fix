#include "cursor_policy.h"

bool pd2ccf_rect_equal(const pd2ccf_rect *a, const pd2ccf_rect *b)
{
    return a && b && a->left == b->left && a->top == b->top &&
           a->right == b->right && a->bottom == b->bottom;
}

bool pd2ccf_should_apply(bool active, bool desired_valid, const pd2ccf_rect *desired,
                         bool current_valid, const pd2ccf_rect *current)
{
    if (!active || !desired_valid || !desired) {
        return false;
    }
    return !current_valid || !pd2ccf_rect_equal(desired, current);
}

pd2ccf_release_action pd2ccf_choose_release(bool owns_clip, bool last_valid,
                                             const pd2ccf_rect *last,
                                             bool current_valid,
                                             const pd2ccf_rect *current)
{
    if (!owns_clip) {
        return PD2CCF_RELEASE_NONE;
    }
    if (!current_valid) {
        return PD2CCF_RELEASE_RETRY;
    }
    if (last_valid && pd2ccf_rect_equal(last, current)) {
        return PD2CCF_RELEASE_CALL;
    }
    return PD2CCF_RELEASE_DROP_OWNERSHIP;
}
