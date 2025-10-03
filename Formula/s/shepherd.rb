class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftpmirror.gnu.org/gnu/shepherd/shepherd-1.0.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.7.tar.gz"
  sha256 "325a9b7581ee83a15115dfbfbcc247c9eb510f752549a23f3ae912a8ec727597"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "4207333c35b99dcdd78f2542b1ad1dac48c5dd6ae1526a39f6736945cbf78177"
    sha256 arm64_sequoia: "4207333c35b99dcdd78f2542b1ad1dac48c5dd6ae1526a39f6736945cbf78177"
    sha256 arm64_sonoma:  "4207333c35b99dcdd78f2542b1ad1dac48c5dd6ae1526a39f6736945cbf78177"
    sha256 arm64_ventura: "4207333c35b99dcdd78f2542b1ad1dac48c5dd6ae1526a39f6736945cbf78177"
    sha256 sonoma:        "d8ad6fa793dbf9da37e69c9522494bec375cdd835de75ed82dfb51f4c67e3963"
    sha256 ventura:       "d8ad6fa793dbf9da37e69c9522494bec375cdd835de75ed82dfb51f4c67e3963"
    sha256 arm64_linux:   "85951781850470d072f8959f3d658e71628e6b8926347c94a5695ca404f3c3e1"
    sha256 x86_64_linux:  "a8482d3bcbd91c2db1b208608f65386bc774531ad8f2b64059691bec16c2ab8a"
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
