#include <assert.h>
#include <stdio.h>
#include "cursor_policy.h"

static pd2ccf_rect r(long l, long t, long rr, long b)
{
    pd2ccf_rect value = {l, t, rr, b};
    return value;
}

int main(void)
{
    pd2ccf_rect a = r(0, 0, 1920, 1080);
    pd2ccf_rect b = r(1920, 0, 3840, 1080);

    assert(pd2ccf_rect_equal(&a, &a));
    assert(!pd2ccf_rect_equal(&a, &b));
    assert(!pd2ccf_should_apply(false, true, &a, true, &b));
    assert(pd2ccf_should_apply(true, true, &a, true, &b));
    assert(!pd2ccf_should_apply(true, true, &a, true, &a));
    assert(pd2ccf_should_apply(true, true, &a, false, NULL));

    assert(pd2ccf_choose_release(false, true, &a, true, &a) == PD2CCF_RELEASE_NONE);
    assert(pd2ccf_choose_release(true, true, &a, true, &a) == PD2CCF_RELEASE_CALL);
    assert(pd2ccf_choose_release(true, true, &a, true, &b) == PD2CCF_RELEASE_DROP_OWNERSHIP);
    assert(pd2ccf_choose_release(true, true, &a, false, NULL) == PD2CCF_RELEASE_RETRY);

    puts("policy tests passed");
    return 0;
}
