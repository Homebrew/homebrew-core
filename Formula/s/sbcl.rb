class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.0/sbcl-2.5.0-source.tar.bz2"
  sha256 "2e18afd088e4a2df21b77bae2e170ce570d11da6d27607292265f1cc6a8a19b1"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "867711dac81ac24df3ea192993517fa2a34c3d4f498f7a68e44387f55ce3aab9"
    sha256 cellar: :any,                 arm64_sonoma:  "d12731edd267ffe90e5b1476da6ddbf39ecafab474bf6c234db85fe96d306ecf"
    sha256 cellar: :any,                 arm64_ventura: "e36918c3b669f7b70b20fd44487fb5e48670fdac11c68b91d3f94ca738c5c084"
    sha256 cellar: :any,                 sonoma:        "a7aa6fa9fbeb2969c0b6130b2f74bc8f862275e2c3b8e344b8c6b4afe8c269d7"
    sha256 cellar: :any,                 ventura:       "ec95ffcc95abd4802a09e75ef45fc276783fbeb912986ac8eb5405bcaff1c28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff92c82892db07015e0a9419b90915be4a18f46c42cd5cbd408bbde98aedc42"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
