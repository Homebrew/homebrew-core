class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.4/sbcl-2.4.4-source.tar.bz2"
  sha256 "8a932627b3f1d8e9618f1cdc225edcb002456804697e2c87d140683764a106d5"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b0b35f2a78727ba8d60cc9c04001ff9a36169120a0f7e111f5dda3a46b9e288"
    sha256 cellar: :any,                 arm64_ventura:  "4a6a24a422e4011090c20e080a3499dcebdc981da86bd59724d200f39259f794"
    sha256 cellar: :any,                 arm64_monterey: "ff175e4cc4b0fa95fa90be723610bcd831d74fd1bf7e095ef65e20a8bbb9030f"
    sha256 cellar: :any,                 sonoma:         "744333da0c588b4aeb4fb9b5b347eb6948547907615da720dfc98d4d04a334ad"
    sha256 cellar: :any,                 ventura:        "3d8790cb3cd7a51151f530a3bd3dcd0eac65d4d7135f52ca27180e6391bef82d"
    sha256 cellar: :any,                 monterey:       "be551d270d754d3b8d615b6a2c89b6b7ee50705260ab994877eac14188877ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9852fffd1c26d4a9bad3edb99f48a8cf6a957c6157038c51d42734d464f47278"
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
