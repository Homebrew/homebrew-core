class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.10/sbcl-2.3.10-source.tar.bz2"
  sha256 "358033315d07e4c5a6c838ee7f22cfc4d49e94848eb71ec1389d494bc32dd2ab"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e4a0c94caa220dbadc37becbb9045726f0f6cf51a1ab3a6fb297dc750bf4583"
    sha256 cellar: :any,                 arm64_ventura:  "6a635e73c0428c20e1e2c0965087ea68652b53b56ac7c7d8ce694d79aec08996"
    sha256 cellar: :any,                 arm64_monterey: "910a294d74dd3a6ad32a507d5056b613e6944935d5f7641393f9699121d9da81"
    sha256 cellar: :any,                 sonoma:         "adacbea69f4db7ab032448956123c649cf1f6a2d4a8026ffd6e35de328af93a4"
    sha256 cellar: :any,                 ventura:        "bd96771f52e555fcd2837369ae73196328223039c3b51df0b398ee47e6681e2a"
    sha256 cellar: :any,                 monterey:       "f7f76808f4f27202b6e2d0173afb814fa839fe23b825eec63f95731276f71e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf5fd31d100f1e8b9bd03413119266110a8b9ab08d6653f856f0ee2a964ebf7"
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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
