class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/shepherd/shepherd-1.0.3.tar.gz"
  sha256 "40e779eb5ffd76fbe85cde9533d37f0da980462853e01974816093f5510bf3d8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "92dd55947b82454d0dfa1b612f622228f12a3035e399d752df976166c1fe63f6"
    sha256 arm64_sonoma:  "92dd55947b82454d0dfa1b612f622228f12a3035e399d752df976166c1fe63f6"
    sha256 arm64_ventura: "92dd55947b82454d0dfa1b612f622228f12a3035e399d752df976166c1fe63f6"
    sha256 sonoma:        "03c45d910c428bf5929cce224fab09328e523e4a609ca13e9dc50ac14153c15a"
    sha256 ventura:       "03c45d910c428bf5929cce224fab09328e523e4a609ca13e9dc50ac14153c15a"
    sha256 arm64_linux:   "ae9e62453747bbc46d898fda7b9e4975ac141eccfd3339a135cc8cf189f61573"
    sha256 x86_64_linux:  "980b5f3649773d333687d902a57f2b1b406d9c06bf8b76f5c5e25ca465b4c8e4"
  end

  depends_on "pkgconf" => :build
  depends_on "guile"
  depends_on "guile-fibers"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV["GUILE_LOAD_PATH"] = Formula["guile-fibers"].opt_share/"guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = Formula["guile-fibers"].opt_lib/"guile/3.0/site-ccache"

    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dummy-service.scm").write <<~SCHEME
      (use-modules (shepherd service))

      (define dummy-service
        (service
         (provision '(dummy))
         (start (lambda ()
                  (format #t "Dummy service started~%")
                  (values)))
         (stop (lambda ()
                 (format #t "Dummy service stopped~%")
                 (values)))))

      (register-services dummy-service)
    SCHEME

    begin
      pid = spawn bin/"shepherd", "-c", "dummy-service.scm"
      sleep 2

      output = shell_output("#{bin}/herd status 2>&1", 1)
      assert_match "socket: No such file or directory", output

      assert_match version.to_s, shell_output("#{bin}/herd --version")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
