$(document).on('ready page:change', function() {
    $(function () {
        $('.datepicker').datetimepicker({
            format: 'DD/MM/YYYY'
        });
    });

    $(function () {
        $('.datetimepicker').datetimepicker({
            format: 'DD/MM/YYYY HH:mm'
        });
    });

    $(function () {
        $('.timepicker').datetimepicker({
            format: 'HH:mm'
        });
    });
});