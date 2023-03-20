class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.15.0.tar.gz"
  sha256 "957bda396be04e4332082db401ff84a134067d0605b3eceff7143ee67b643c9a"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9362664f2bb4d9dae51faa42cd481436b52207eff0b8766f8df71925e0ee0ca3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4b647e943f114b817cce69133b055f99a6f6f604264510615d5a9b1bdca551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8097a1f8d5799cd6d48ba7b1f1250501fb35835f0c1911847a66af36f3321493"
    sha256 cellar: :any_skip_relocation, ventura:        "5ebdbd1211a9cf2e76629993bf5aee91cc05bac043494de4861652041cd99ef0"
    sha256 cellar: :any_skip_relocation, monterey:       "d9f8174cdb569278bd9bec992c61a963ab3e33410f19979911f8a58d6bedd6cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe6532bb0240190a83ba249977b92e58c9ffd1fa727b750a4f191901e0bd3a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab4e209d4dadf08807cbd9292364b65d32777440dc64d535fad510208946d92"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
