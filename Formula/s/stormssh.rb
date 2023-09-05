class Stormssh < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to manage your ssh connections"
  homepage "https://github.com/emre/storm"
  url "https://files.pythonhosted.org/packages/0a/18/85d12be676ae0c1d98173b07cc289bbf9e0c67d6c7054b8df3e1003bf992/stormssh-0.7.0.tar.gz"
  sha256 "8d034dcd9487fa0d280e0ec855d08420f51d5f9f2249f932e3c12119eaa53453"
  license "MIT"
  revision 9
  head "https://github.com/emre/storm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1a52f812dc26af292eb286347a38a1b2d1530ff6dba1b87bdfcfc6fd5ed00576"
    sha256 cellar: :any,                 arm64_monterey: "b946e40a8b373e97d11f4f9f71e07bc4a9d550e2c44372eb8b5f44b4bec6cb02"
    sha256 cellar: :any,                 arm64_big_sur:  "730ee4ca3a5f5b6c31f8f13da068b1a930688a5b59b05aeeeb7ca3cb7f3bac9f"
    sha256 cellar: :any,                 ventura:        "66600c88a01a9afb40233fad01f83852cfb195c94b20834ffd4b4756efc9c589"
    sha256 cellar: :any,                 monterey:       "026e5179db5a2dfab9c92106cc06965503ca796aef68030390df4599f1b25037"
    sha256 cellar: :any,                 big_sur:        "1a7c8cffd920f3f01fea0b079e55c4fc40a1841b4367812f0c555e08954091ee"
    sha256 cellar: :any,                 catalina:       "bab62435b3dfac2c01663a99e632bd0c04ff3c299676d40fe94d27508c748466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df73798729fb9dd5d28e815344850f973d9d469dc270192f8b8d8070a0d3e186"
  end

  deprecate! date: "2022-11-28", because: :unmaintained

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with "storm", because: "both install 'storm' binary"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e8/36/edc85ab295ceff724506252b774155eff8a238f13730c8b13badd33ef866/bcrypt-3.2.2.tar.gz"
    sha256 "433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/d3/3c/94f38d4db919a9326a706ad56f05a7e6f0c8f7b7d93e2997cca54d3bc14b/Flask-2.1.2.tar.gz"
    sha256 "315ded2ddf8a6281567edb27393010fe3406188bafbfe65a3339d5787d89e477"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a1/9b/737c2306468a9fce2d630f12c2f29a2674d7bbe406819334c0883e929812/paramiko-2.10.4.tar.gz"
    sha256 "3d2e650b6812ce6d160abff701d6ef4434ec97934b13e95cf1ad3da70ffb5c58"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/cf/97eb1a3847c01ae53e8376bc21145555ac95279523a935963dc8ff96c50b/Werkzeug-2.1.2.tar.gz"
    sha256 "1ce08e8093ed67d638d63879fd1ba3735817f7a80de3674d293f5984f25fb6e6"
  end

  # Support python 3.10, remove when upstream patch is merged/released
  # https://github.com/emre/storm/pull/176
  patch do
    url "https://github.com/emre/storm/commit/5a4306b90060f6109611df49ac480f1300e35acd.patch?full_index=1"
    sha256 "38e44cff45aef6549574777fb4fdbc065604d0a8918d26a3de02f1570ae1bb92"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    sshconfig_path = (testpath/"sshconfig")
    touch sshconfig_path

    system bin/"storm", "add", "--config", "sshconfig", "aliastest", "user@example.com:22"

    expected_output = <<~EOS
      Host aliastest
          hostname example.com
          user user
          port 22
    EOS
    assert_equal expected_output, sshconfig_path.read
  end
end
