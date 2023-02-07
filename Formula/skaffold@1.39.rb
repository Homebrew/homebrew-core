class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.5",
      revision: "64f6ffd59dd1c76e73ae41cd81a712cd1726c5e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "542b24c1d9093b2f55ac99bc558e961b466afc1475e027905d0e2ba0dfde97a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14a909f9b72a9f0183ff7664db7ae0d879b706542d49200061fbe2e1cf7c0082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94a5defad2bb6983837dfcc2e0fdcb5bfca68f7916c26d957686dfdcfc299532"
    sha256 cellar: :any_skip_relocation, ventura:        "0e0416d49c95e06703d5d8b464e1bff4369dfdf67bf57b4d7564d19643fe9798"
    sha256 cellar: :any_skip_relocation, monterey:       "9f729b710295b0e064b66eac25572bd6c34abd36ed122f462cac53e502d862c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "843d99b331dac6c852a35fdd070bf4afc342ac235717db48cc1f5abceb8d10a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "514be169d944e9c72f67f85333046e9f28e11200cec8a1b41fea327ffb169a6c"
  end

  keg_only :versioned_formula

  # https://cloud.google.com/deploy/docs/using-skaffold/select-skaffold#skaffold_version_deprecation_and_maintenance_policy
  disable! date: "2023-10-18", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
