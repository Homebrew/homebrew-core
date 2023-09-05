class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/v0.1.44.tar.gz"
  sha256 "2ce8d77ab00235ea341ce92ebae9472b453a059ce8e3333bb030a44d90fd9a9d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d21d06608ee03028250c6d090168cd66474fb8d7b4ab59266538f799d11b23be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2789285c425a2e62687983909654d835647eee0025b4e70f1eedaef2a5d9551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da08ef1c4eb998c860e55af4a4c823b0b87c356f157f6df7d35e50b9168cbd01"
    sha256 cellar: :any_skip_relocation, ventura:        "3450966a5b71762f584f6dea06bf9059a3d562e5123f321a51157c2bb0f6dc33"
    sha256 cellar: :any_skip_relocation, monterey:       "2cc7705152fbae2fd8111c540dd1469230e2213c996bb764a122f3e81e27d167"
    sha256 cellar: :any_skip_relocation, big_sur:        "a794e28c58aaa3979782af57478d680bebb445c7d6ef30238c17680769e1d005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899d33fe4bc826627dd56792e066c55fc80fe13c48849bac2a216dd86c9ad158"
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
