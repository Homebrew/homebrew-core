class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "639c1fe14aee5e34b635de041ac77177e2959cf26072d8ef69c444b15c8273bd"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2694fb155f4988be81bd67c050d325e5dd9f62e5bac209cf5d19eabfaa7fad79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48035c9823fcc6893b4fa87efe62cffc560067953ec9d682a479f17020cf209a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8413ae0bc937ec8ef32a51c5f54875fb0132716a8026b187da9309b69f537c37"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eaa2b1b7c7f62d56276d991a3447082dbc272483d57a1acf098a552f960f496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db070777cb64b7e976373584ef41b92f3ab244607ee0ca8900a4d6c5270bc44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664ccb5be9cf3f304250d248a85e633b9baa1804bebcf46c67672aebe5ecfcc5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e_Gi=31,s=1,v=1,a=q,t=d,f=24;AAAA\e\\\e[c\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
