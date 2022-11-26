class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.0.2",
      revision: "d45fee5c7f7441d551aeed9c90750a1ff4fe1cbc"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3a08c704b5e2ec89107d7434ee2e9b35436a14c37ef17628fe34cd46806a9d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebab17a203c37263fe4bf173a6ab0994e5c14f7eef21efd0c99b1f99f0d5de66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17f64d506ac03f2c879ef25e05aca0549ab2ead354b39bbfb8f7b9272ef08560"
    sha256 cellar: :any_skip_relocation, monterey:       "d1291fcd6e13fb0d6317ca997ee4a8613c2e4f5e0a460fc7338b69bd499231db"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e1013be67d191dda40cc818705ae2c9c3a23ee9b73e31c2c50362daf80999aa"
    sha256 cellar: :any_skip_relocation, catalina:       "f2fa9363a519c3b41653c3533f7cd2364420a61f5606d9214c79d62c8c88b9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "996a5ea74893b941ab46cda4c948486fe849de523a83bfeb195d4063903d082e"
  end

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
