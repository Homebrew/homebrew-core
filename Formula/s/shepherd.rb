class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/shepherd/shepherd-1.0.5.tar.gz"
  sha256 "3c475069a02b49018491e5a5bbab5b7a424d76c7a06bdbf47afd005dc86805f8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "3f6a310d4f6d89dbfde112dbfc77e4645fc01abb871e1726bb7972aaa5405b02"
    sha256 arm64_sonoma:  "3f6a310d4f6d89dbfde112dbfc77e4645fc01abb871e1726bb7972aaa5405b02"
    sha256 arm64_ventura: "3f6a310d4f6d89dbfde112dbfc77e4645fc01abb871e1726bb7972aaa5405b02"
    sha256 sonoma:        "04cffb4fb608ef2560a2c43eac9a501990e8ffcfee62325b910624ec304ea2c9"
    sha256 ventura:       "04cffb4fb608ef2560a2c43eac9a501990e8ffcfee62325b910624ec304ea2c9"
    sha256 arm64_linux:   "63cab7b806076518b16193ed9303f6ce777b07d5b515dddaef81028a4864c6bb"
    sha256 x86_64_linux:  "8cfc61fa0dfc40ac143e61c8bee46023f12659e0648fa9700f446ad0afa3b566"
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
