class Since < Formula
  desc "Stateful tail: show changes to files since last check"
  homepage "http://welz.org.za/projects/since"
  url "http://welz.org.za/projects/since/since-1.1.tar.gz"
  sha256 "739b7f161f8a045c1dff184e0fc319417c5e2deb3c7339d323d4065f7a3d0f45"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?since[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b463dd2eefbe33098ec0a7d4b1f98e186559a7d14d54e3ac5922873f871f6364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "07893929437e39dacfc617af4ec38af1153bbd8a3655992293b1ac8c415ac240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccf2421f8310655e3579181a2127aa8897340b05ee8c1d1a2fe5ae8d856793b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70fe591dc225eb74e0f27c8d8f913771f6873665fd9441498ffeba1c277358ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be177eae27c7bc16dcabf649437a4b99dc2bcba9b4771d2038844785a3150b7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95b9b96522d9cdb0ac317550daf1c9ee102d1a4df7736cd2072d896adf05fc04"
    sha256 cellar: :any_skip_relocation, sonoma:         "33908d6e9b5baf6b2d9b02fd43a46860eb89ad4e2371ed63f83dcfcd4bc50c28"
    sha256 cellar: :any_skip_relocation, ventura:        "75b5ed6525afee018674228668bf45b282016187f09dd42dd95fb474e0e1a232"
    sha256 cellar: :any_skip_relocation, monterey:       "3db05c5b4e33cc28cf9dd8352dbc6038b139cb6bf8056bc9c5a85bd0db7ee9c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c3738e71c6455fa5a7445a21a79695d4644a34de06cbc05743a52c4f5b40f8"
    sha256 cellar: :any_skip_relocation, catalina:       "20b3f4888282ed47021562eb24efe9c37ef3a652ad64164460a5f368260e75d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e0686ce3cedc670157058d0c768236fd2276290197884ab1759aeba4f60789fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db033c09d09fa627dd0d98d52a4b32231a6f696f925c77b0c91d7b8f057ea3f4"
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "prefix=#{prefix}", "INSTALL=install"
  end

  test do
    (testpath/"test").write <<~EOS
      foo
      bar
    EOS
    system bin/"since", "-z", "test"
    assert_path_exists testpath/".since"
  end
end
