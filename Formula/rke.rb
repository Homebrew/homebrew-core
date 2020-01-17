class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.0.2",
      :revision => "26a1365ddb58ec065101d2042c66da04e17bcfca"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e7832e54365f203295d934bd573dd2a8ddaba31cfaee0baa4884aadc928266a" => :catalina
    sha256 "5402d63830e8e5a1faabcef752b980ff8266ee5ef562b816a62d22ea8336497a" => :mojave
    sha256 "c2e7233a7fdea5915340e8472cd56df4fb9e2b4bc1b716511d4fe52ae07ecf89" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke").install buildpath.children

    cd "src/github.com/rancher/rke" do
      system "go", "build", "-ldflags",
             "-w -X main.VERSION=v#{version}",
             "-o", bin/"rke"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
