class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.2.5/sbcl-2.2.5-source.tar.bz2"
  sha256 "8584b541370fd6ad6e58d3f97982077dfcab240f30d4e9b18f15da91c2f13ed1"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71409c947f8913657a9d76e34d1e7bd6e61341a9e239ce2f7c416b1d263e25c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2ded6378b6c3c1ad354a72b439e0bf3ea770524a8112457951af4ce9149d2c8"
    sha256 cellar: :any_skip_relocation, monterey:       "74050aa4cfbd6c9438e9a0b9ccddc1e7b97dd4d804e5d6af5182fc9b5c00ff3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "76a902371fbd89891ac8f175ee7c9ea06061548c2fb861b7f9a0d87bcff28f39"
    sha256 cellar: :any_skip_relocation, catalina:       "1978a420753d12d814aac77b7eb54bc66c67ee4a2bd55f3efd725ea907af00cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66a7ff7718002ecf8c562c6bc937698abb1b0928d6467dcb0149a5e248daed0"
  end

  depends_on "ecl" => :build

  uses_from_macos "zlib"

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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
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
