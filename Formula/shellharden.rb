class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.3.0.tar.gz"
  sha256 "d17bf55bae4ed6aed9f0d5cea8efd11026623a47b6d840b826513ab5b48db3eb"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af4c4531c0e2af03ab01cb7002dbe4c0b9216531d3357a0cc984767cf333d20b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ab26af4b397db53c4118608c6752e7b37200348bdc7e3f5d9774aba8d9563a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41d6e352a23075865bf5b50a79c2e85feb0fa80a8fb6c99397bbe5a33466531d"
    sha256 cellar: :any_skip_relocation, ventura:        "91cac0ef8ad9379fa304345396b22b3ba5747b39e45163c40e0a659a8e7eedb6"
    sha256 cellar: :any_skip_relocation, monterey:       "4e9357aebe45d1e473c70d05c34dade5dc9d510f7dcc845933129e2dcd22ec56"
    sha256 cellar: :any_skip_relocation, big_sur:        "6481b5f71159d7afc13d7bfd1798483ebd0fe46ee168302e9e48938c55f0dd07"
    sha256 cellar: :any_skip_relocation, catalina:       "b3b53405b95f10baac16f954fc2295d39177aa8b70653c151d25d0f0c287bae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a59a10d57b518b7ebb1168f09c7ef397448d6df530cc0674e9aa8c061975a9"
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
