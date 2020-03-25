FROM facthunder/cppcheck

COPY perform-check.sh /perform-check.sh

ENTRYPOINT ["/perform-check.sh"]
