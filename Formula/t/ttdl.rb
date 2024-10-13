class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "443b8d0121577dd30603ff42247ca9a6bd04c455b7b095e980c63ea6286843c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1899f9e7ebbfea3704d9fdae2f12970d305c19253421c69aa1a32ba19b45cc98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe56dec6d7b9b7114e80f4336fc9ca78ecfafc6a923bc7f3a62f292eac6a75d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d7cb342fbbb4fd51a3fa7a667c3e422690367d182fdcd94b40ace7c3b41bf77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd2fc8c781841d0c7f45a246ceae2cdf499fc2683ea3e6a786dd05f4824102e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b6f8080b3c5f5e55414dd6c88061b7071ea7476d0f5c5f80459c7d0db39bba9"
    sha256 cellar: :any_skip_relocation, ventura:        "fbd8e9ad36c3a2bb9c92323bd1767112fb118378522724da18e4fba09f196250"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f46ba7f13876c8a268bac03c0700ffc5d05fde0104d4a99c7ad80522e592bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c73e13136a38420ab33b7219338dda9824ecbe9bf3bb7edd1be4999a57d6c39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
