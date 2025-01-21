class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/shepherd/shepherd-1.0.1.tar.gz"
  sha256 "895d0051e1cc473b1f79f63913777b4d15f89f16d0a723774176da102e2710c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "740ff4879eb0b645160af23435a9577f507d4b967d67f2134dcba7d42f99e36c"
    sha256 arm64_sonoma:  "740ff4879eb0b645160af23435a9577f507d4b967d67f2134dcba7d42f99e36c"
    sha256 arm64_ventura: "740ff4879eb0b645160af23435a9577f507d4b967d67f2134dcba7d42f99e36c"
    sha256 sonoma:        "b6956667e60138b0f47296a9742fa98a730a101a2bd89945392e3266d0160de9"
    sha256 ventura:       "b6956667e60138b0f47296a9742fa98a730a101a2bd89945392e3266d0160de9"
    sha256 x86_64_linux:  "dc48d821c2067b81c6bf86c04a659aaa781d96a6e4bfd80da9b54b22f6342f4a"
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
