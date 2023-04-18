class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "975def29e5e365b93b050a42cb0a84dc7469c37ead69fb61f0d892d412d262e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eb0ae8576af1f2296862fa155f5e3a67b2b9febd488ec88678c62e237590cd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8339d25f0b98afe28e5ea7b8c8f60e2cf0cde73bcfbdeb4a450e23f4d1280ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b10ecc0cfc95829d76ab8129db550fb153664838e255811cedb8288e98a1c59"
    sha256 cellar: :any_skip_relocation, ventura:        "0c975ddce3fa89e4e3e85ccb2892021ae97444971cda23bc129700d408ef7f54"
    sha256 cellar: :any_skip_relocation, monterey:       "f11300490871e9feaf6694f878379d92139adde445dd01ccb80656319d2b26ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9dadb8360fc7a04e930b1701de41f47fcfa0412b077acf5a0cb9cc56584ff11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f586084481b163e38330c3cf5ea799c89f0d530b145a70b3001daeb57062dae1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
