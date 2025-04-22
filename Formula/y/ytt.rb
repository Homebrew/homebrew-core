class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "c795c388612d93a2a139fce378b5721db2404a2a70fb3d67124931453b11f163"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d442c92b422f125631bd3810a1325915b723ade414d152c2e8e400b2c674c36c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d442c92b422f125631bd3810a1325915b723ade414d152c2e8e400b2c674c36c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d442c92b422f125631bd3810a1325915b723ade414d152c2e8e400b2c674c36c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8670f9590fc7b28812ca115049835ca966298308557e58ae2c2c7303f0f516bd"
    sha256 cellar: :any_skip_relocation, ventura:       "8670f9590fc7b28812ca115049835ca966298308557e58ae2c2c7303f0f516bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2cc30cb9ebd651a3418fd18dc5724e6c18bb276b675baf2bb3ec067fc8705e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"

    generate_completions_from_executable(bin/"ytt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytt version")

    (testpath/"values.lib.yml").write <<~YAML
      #@ def func1():
      name: max
      cities:
      - SF
      - LA
      #@ end

      #@ def func2():
      name: joanna
      cities:
      - SF
      #@ end
    YAML

    (testpath/"template.yml").write <<~YAML
      #! YAML library files must be named *.lib.yml
      #@ load("values.lib.yml", "func1", "func2")

      func1_key: #@ func1()
      func2_key: #@ func2()
    YAML

    assert_match <<~YAML, shell_output("#{bin}/ytt -f values.lib.yml -f template.yml")
      func1_key:
        name: max
        cities:
        - SF
        - LA
    YAML
  end
end
