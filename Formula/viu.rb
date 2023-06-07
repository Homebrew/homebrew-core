class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9b359c2c7e78d418266654e4c94988b0495ddea62391fcf51512038dd3109146"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5518815ffa424b2f4341703d8e12b62a7b0c7b86591e24e48f22e5dbebf9499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31abf104e6a99f2168f865b6461657aa6a7a30c014239eb72f76bffc525bec95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fefcfa184185f643d81e7a206e782349a0813e947222f2ea092eff3f92dfa5b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9729333077ff480c91b5cba9108ba95dfff75fc0860c76691b4434932c066b10"
    sha256 cellar: :any_skip_relocation, monterey:       "9f01ea745004309835c0ee4ebee71ff8186246ea0c74b2c5286a3f021d425238"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d88e2dcf78308bdb60b2072cb03a31d6fad4d84d760360b597feea0a0a1b2a5"
    sha256 cellar: :any_skip_relocation, catalina:       "d2082f85f1290d91864b6ff81b8ea76c93ae6482cf5375efede73afe69bb96fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9affa5440243080d044e7dce00b6d2efa411cfcbbbce88aeb4c2b5268b5107a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
