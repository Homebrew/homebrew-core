class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.8.0",
      revision: "ba02de8494a2cfe36249087871e9c7aa80fc535e"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa4abd16b3788005dfe2534f730ae120c21bd137e605c42191d25f9791553f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83f468a0287db1686dc46f64191f4c52f01fc913494bbf7a2dba065bb02be5d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07408ae9f634f3e1069e00be9027c0ac4d37b4921ea590ed5db675e9cf23fb13"
    sha256 cellar: :any_skip_relocation, sonoma:         "055dae7ed61d672ddb653e7de8369711a32f4d2d445d02361a48696df890fb99"
    sha256 cellar: :any_skip_relocation, ventura:        "eb7e37fe1a790e34a85f162c9f3778be17a54922329957119126f0e9bac0f76e"
    sha256 cellar: :any_skip_relocation, monterey:       "d332ee07acd164fd28096bfb9977c3b0c80dcf46b67733bc7e65afc87905bc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd0b05e892f0e0fb57a25d64fb64af6c191070c3525650b4ec37104a9992d37"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
