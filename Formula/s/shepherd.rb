class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/shepherd/shepherd-1.0.4.tar.gz"
  sha256 "13306a6b56dfe252464e84a23c23a7234338cc752c565e1b865f7cbf8a03f0cf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "0e77cd94045e538a8377a54f6bbbe67c0a34cc5e81cd8d673c77fd2230761c1a"
    sha256 arm64_sonoma:  "0e77cd94045e538a8377a54f6bbbe67c0a34cc5e81cd8d673c77fd2230761c1a"
    sha256 arm64_ventura: "0e77cd94045e538a8377a54f6bbbe67c0a34cc5e81cd8d673c77fd2230761c1a"
    sha256 sonoma:        "c5e9efa74d96feaec6b21cb3e0d02ec4ecd81aabca71dc98f38e5533d905a040"
    sha256 ventura:       "c5e9efa74d96feaec6b21cb3e0d02ec4ecd81aabca71dc98f38e5533d905a040"
    sha256 arm64_linux:   "7e7957d6d4b3077679f4ed9ed819ed41459658e8fc20cda9198ee6435ef32eb4"
    sha256 x86_64_linux:  "e420d97cd462631adf4e0088251a3ea3efc1804b24cd16ebc2d012fcdc40d993"
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
