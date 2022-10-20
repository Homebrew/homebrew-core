class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.3.0.tar.gz"
  sha256 "d17bf55bae4ed6aed9f0d5cea8efd11026623a47b6d840b826513ab5b48db3eb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c8525684651d85143be5ac387c06022d6835baed6e89186059a87965933e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93b47497afa27aa01162fec596e424267ef81422f56905e60c4ab3227da33d80"
    sha256 cellar: :any_skip_relocation, monterey:       "5087ce0fc26e832233f0b332db359e8f1f7fbf7a262367ac4d93a342fd398c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa242a3bcd43c255bec74cd2ecf7c81db02f050e47a7f9dd51b9fd115a5af85f"
    sha256 cellar: :any_skip_relocation, catalina:       "375834c3981e6328e27bad083c5143b09bba2cf4e90c2e1919ca40078991ac87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf877d535d1efa19a2f62b6e1a70387ec5c7d83633bcba2f938e997c9f4ca27f"
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
