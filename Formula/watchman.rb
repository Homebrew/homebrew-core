class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.7.0.tar.gz"
  sha256 "77c7174c59d6be5e17382e414db4907a298ca187747c7fcb2ceb44da3962c6bf"
  revision 1
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "07e826368e27cc7401366d820cc8109fec8bd815143ec75b30a81cc0b84d766f" => :sierra
    sha256 "bcea4d625e7c30ecc6f728e257f5de81125c7f14680cac684bc7c878655e167c" => :el_capitan
    sha256 "c8374abbad804b919c372d6883302654b44b8d4b190e06b6e4dad172e038bf51" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
