class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.5.0.tar.gz"
  sha256 "ef11ad11f3b79a09232a27d993331cc8b686fe06a8f0e7c777cb50cc198020f6"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "b630babd018142fb1fb8874444595a26ee99b361ba559308cf5cfd0df1486e7c" => :el_capitan
    sha256 "bcd3b0f4ffaaebadd043fd928dd72aa6213d87b8af162e8853689200de6fc4c9" => :yosemite
    sha256 "74c19390f79a0ca19faa5290f1e494cda14390606bb891a43cf8957d0098a3dd" => :mavericks
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
                          "--without-python"
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

  test do
    list = shell_output("#{bin}/watchman -v")
    if list.index(version).nil?
      raise "expected to see #{version} in the version output"
    end
  end
end
