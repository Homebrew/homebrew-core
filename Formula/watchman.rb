class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.6.0.tar.gz"
  sha256 "3a4ea5813967e984acb5bd32327926f2d431ea8a4ab7703510726ddb97d3d126"
  head "https://github.com/facebook/watchman.git"

  bottle do
    cellar :any
    sha256 "71899aab18da9c9eb1328cb456861fdff055e72c52e9870a5f86e3aadbd7cd06" => :el_capitan
    sha256 "cda1ca8b9a8922ed7f8b02b3cc083b19824cc2445ac8811f62a22159bcc1e1f9" => :yosemite
    sha256 "255eff7231fe294a077d25d135da27f7ced524aefb86de852446cfc69ca7585b" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre",
                          # we'll do the homebrew specific python
                          # installation below
                          "--without-python",
                          "--enable-statedir=#{var}/run/watchman"
    system "make"
    system "make", "install"

    # Homebrew specific python application installation
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    cd "python" do
      system "python", *Language::Python.setup_install_args(libexec)
    end
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal /(\d+\.\d+\.\d+)/.match(version)[0], shell_output("#{bin}/watchman -v").chomp
  end
end
