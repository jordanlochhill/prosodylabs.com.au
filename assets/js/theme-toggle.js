// Theme toggle script
(function () {
    const storageKey = 'theme';
    const classNameDark = 'dark-mode';

    const getPreferredTheme = () => {
        const stored = localStorage.getItem(storageKey);
        if (stored) return stored;
        return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    };

    const setTheme = theme => {
        if (theme === 'dark') {
            document.body.classList.add(classNameDark);
        } else {
            document.body.classList.remove(classNameDark);
        }
    };

    // Apply theme on load
    setTheme(getPreferredTheme());

    // Expose toggle for button
    window.toggleTheme = function () {
        const current = document.body.classList.contains(classNameDark) ? 'dark' : 'light';
        const next = current === 'dark' ? 'light' : 'dark';
        localStorage.setItem(storageKey, next);
        setTheme(next);
    };
})(); 