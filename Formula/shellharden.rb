class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.2.0.tar.gz"
  sha256 "468406c3698c98deeabbcb0b933acec742dcd6439c24d85c60cd3d6926ffd02c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d625041f1fbe3eab74c04270fd05050aaba03aee4cd7327298cc56076b257270"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fad7048a92304e23fa0b61f52a33a481b9fd4b92d9d05f1fd4c8ae4592adc8a"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff3866f623e46915cede8a4fae524cd3bc1617bea2b021fd6137e7ed36183ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ac2c0a82a51438f5f9de526e63a962e20e84d31383afe6dd3440d5477d3c1ee"
    sha256 cellar: :any_skip_relocation, catalina:       "0f61dd945c675db1d7be6cc124ed4af85b1973bcd4a83a58ca76094b88885c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39ca4ad421695d03bc72d815214ead62fb236d96c7c3cad3265fd6998b8c694"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"script.sh").write <<~EOS
      dog="poodle"
      echo $dog
    EOS
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
