class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftpmirror.gnu.org/gnu/shepherd/shepherd-1.0.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.8.tar.gz"
  sha256 "3beb005370bf0339c567d068a7ad9fb69f0e8850894db01c34635955f7717ff5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "ab697e56b7681791843ef13b65fe83e6ce99097b8aee641b54c5725a5103ac9f"
    sha256 arm64_sequoia: "ab697e56b7681791843ef13b65fe83e6ce99097b8aee641b54c5725a5103ac9f"
    sha256 arm64_sonoma:  "ab697e56b7681791843ef13b65fe83e6ce99097b8aee641b54c5725a5103ac9f"
    sha256 sonoma:        "f186f200570abd84794dd574570953e546ebd572e09e9fec5a02601bb56388c4"
    sha256 arm64_linux:   "d563a768de514ed5d4fc4c897a89193224ea3b82222040dbda2e2dd9f2abf212"
    sha256 x86_64_linux:  "8b287ccf5c5cf69aa12dc4eee2f979979ef13f2a317804954d7ff419abf77598"
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
