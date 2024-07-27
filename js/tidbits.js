document.addEventListener('DOMContentLoaded', function () {
    function calculateAge(birthday) {
        const ageDiffMs = Date.now() - birthday.getTime();
        const ageDate = new Date(ageDiffMs);
        return Math.abs(ageDate.getUTCFullYear() - 1970);
    }

    const userBirthday = new Date('2008-09-14');
    const age = calculateAge(userBirthday);
    document.getElementById('age').textContent = age;
});