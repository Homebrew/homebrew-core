class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "e0a1ee709fecd19777c3e5f434e51ec4e1716de14bf68b8efcecd8bb68508f78"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2060d30660836b41e7f18b949430d6584a736749830a75aeeb6ec06dde7cd070"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f79844bce767dfcc4f83813cd6cb5c11efa31479e4aa3b33a463c639dee06c7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "584078a0da14890c5b92bfa147c3b13d11917908959690b2fe021b6492ab3d6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "088310999816ced9c375e1372178a49d9424154b7f7b75b617e3de12ce9c5a9e"
    sha256 cellar: :any_skip_relocation, ventura:        "67c64ae6d10e842d0ff9c9f1bcd5c9d311be60f809427c0a761dd5890bb32140"
    sha256 cellar: :any_skip_relocation, monterey:       "0d8fb6a809449309044ffb27a3fa84ea4b2efe745394d23e88390daf75b3dac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db100ac61804d2e48b704c5f0fcd24d982fd7f65d56014359e5bea6bed3f7d7b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
