class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "876d8034f689ea053421eddb6654f76ef9fa18b8400146dff78729ead90fbd69"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a04caa63ad351f5dc222b8a0d54a98b7e9332abc771d3f4fefcafb03fd0c6a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a04caa63ad351f5dc222b8a0d54a98b7e9332abc771d3f4fefcafb03fd0c6a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a04caa63ad351f5dc222b8a0d54a98b7e9332abc771d3f4fefcafb03fd0c6a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d48a33100a2fa1415a314cb40b7ee10aa01e2786b6363d53a857834c1eb2c414"
    sha256 cellar: :any_skip_relocation, monterey:       "d48a33100a2fa1415a314cb40b7ee10aa01e2786b6363d53a857834c1eb2c414"
    sha256 cellar: :any_skip_relocation, big_sur:        "d48a33100a2fa1415a314cb40b7ee10aa01e2786b6363d53a857834c1eb2c414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b852e1ef871f6592a12483fca3a666abddb2ac56c68d46109ba72e1a4e9706e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yamlfmt"
  end

  test do
    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end
