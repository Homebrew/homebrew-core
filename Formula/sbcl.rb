class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.2.8/sbcl-2.2.8-source.tar.bz2"
  sha256 "992fcc2b5319010f7587cdc2294b088a595d6c0982ff195b565adfaf4b7d7b0e"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e16068a0809bae797fd26f008199ceed86c7c18205710a62c7b0db995b05e7d8"
    sha256 cellar: :any,                 arm64_big_sur:  "4e931278c566d7886940112073ce713fda39d4b93f8637292788cfe71ebc1bbf"
    sha256 cellar: :any,                 monterey:       "4c7ca056ef2c4827fb750273945a50dcde9c3f8872a0a46d747934a5a7374191"
    sha256 cellar: :any,                 big_sur:        "14bf977877ab106d87d6328aada25de73013874547d6e8646840b721b0c91f5c"
    sha256 cellar: :any,                 catalina:       "e9402c538fd3bd116ffc6664b5f5d4962ae458484a2267a3e7422f98cd9da896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f7fa408bb4d3b57e041c6f5449193970f4f5bc828078cda252de238eddb31c2"
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
