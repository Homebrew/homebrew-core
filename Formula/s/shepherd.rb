class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftpmirror.gnu.org/gnu/shepherd/shepherd-1.0.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.9.tar.gz"
  sha256 "e488c585c8418df6e8f476dca81b72910f337c9cd3608fb467de5260004000d6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "4d39dcb2ed1d07ec50f5f3dfd56a3d21b07e87893798c9ea6b0f023ba897fae0"
    sha256 arm64_sequoia: "4d39dcb2ed1d07ec50f5f3dfd56a3d21b07e87893798c9ea6b0f023ba897fae0"
    sha256 arm64_sonoma:  "4d39dcb2ed1d07ec50f5f3dfd56a3d21b07e87893798c9ea6b0f023ba897fae0"
    sha256 sonoma:        "fe68652080e171671d839138d2666e60b007ddbfd0d4b880c8a2d21bfa9707bc"
    sha256 arm64_linux:   "7f39f4594b6683c1bacb579bff184a22f0b7ca0f0945231de1b36e4f09770ddd"
    sha256 x86_64_linux:  "3c8fe68ecc151524604daf61c286fe549adba9c68e0c3aae7f7f869ad051ad6f"
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
