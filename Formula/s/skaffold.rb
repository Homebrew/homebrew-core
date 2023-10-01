class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.7.1",
      revision: "4557ab1d4c8361977bbade432169f0aa048f4310"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7de9971c26697abcc12300b691b4c701e34ba2a79d8885c77d39493ea4bf2b92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41963f449a7d607cf65f2c58f692952d9748ef5e45b0eb93ff08aefcad012a75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "879b4ad7b9b4e960585fd777ff8e2ca22a75ae3df45f4beff73e1b5995754e0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b7e250b7402d4b2c0b9ea561d1f3535287e215d64a38b0dad7350ddeabe4a7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "70cbb5e827dcc3dc43da6fe4ea5175733db216074762e44e7d065a77f4fd8f3e"
    sha256 cellar: :any_skip_relocation, ventura:        "d288dc95bca49b65c927cf4c2da350c21bca8a42c8808869e33b8be57157327d"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3148527c09ca5df65d6fb6cab5c6a7b03734e0b17e56b1d6ccaceee6d183f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "644453de89b5a5cbebb96b87d46ac6c2fb89f0820cc66361a9e1fe46796548e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4daa6aef264f11557c507c8529305532f09a5bb3f63a8f892a95061837f9e318"
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
