class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/shepherd/shepherd-1.0.6.tar.gz"
  sha256 "fc74dfda499a695e650fc5839d39ad538e2e323949b8904afcfaffa34171be33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "dda15a8992f9da1097edf9f80e60b209ffc16af10811b31a132577e79d77b69b"
    sha256 arm64_sonoma:  "dda15a8992f9da1097edf9f80e60b209ffc16af10811b31a132577e79d77b69b"
    sha256 arm64_ventura: "dda15a8992f9da1097edf9f80e60b209ffc16af10811b31a132577e79d77b69b"
    sha256 sonoma:        "4af0ab3dc56f5b8e22c3e00bb3e71721952fce09446c85c021ab1ac6c32cd1be"
    sha256 ventura:       "4af0ab3dc56f5b8e22c3e00bb3e71721952fce09446c85c021ab1ac6c32cd1be"
    sha256 arm64_linux:   "d7aaba6f12e4caa47f1bb698e5c061744b7d940b66facb90390c3e2fd0c6ed18"
    sha256 x86_64_linux:  "b72c526c73811d2e697aa70424f54e695982068b253bf0225101d78bc09f7918"
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
