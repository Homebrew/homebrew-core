class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.7/sbcl-2.3.7-source.tar.bz2"
  sha256 "698144fb805a31919a610de999ab98391d52eb698adaa8ca19b28fc6ed0d99f7"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69d937483203320376eead3166ec14e9a1de9c9722a975859c5ffcd5669c8e84"
    sha256 cellar: :any,                 arm64_monterey: "3d66de89cf0f05b1fe126f4f92b9cd6542fe38530e3d692ebae506ee8c3d46ea"
    sha256 cellar: :any,                 arm64_big_sur:  "d1ec61fcbf6fd19d30f25c81fe10dd879dddaeaa7020a824d47ba9a697cb3f56"
    sha256 cellar: :any,                 ventura:        "4c04a9c68f98e135c58d0eed928a14940d226e09c015d5a6ff452d92b7a4be16"
    sha256 cellar: :any,                 monterey:       "8b13b06ce106a9843b9bb97a435b9927a93d9d1c23ce00e26ba1b4f821f9f182"
    sha256 cellar: :any,                 big_sur:        "f4c9e869767afbe3bc96095d214e164c119dea4257e976f4432ab0b5084b64a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ed54ce822f126ae551b1b73cc798e53e933ae81155a9cc6d601be037395105"
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
