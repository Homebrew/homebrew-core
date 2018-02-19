class Sake < Formula
  desc "Automate tasks with Swift"
  homepage "https://github.com/xcodeswift/sake"
  url "https://github.com/xcodeswift/sake/archive/0.8.0.tar.gz"
  sha256 "7198efd02ef3e9992a0a0b16d0342b36f29843a09aebc0c3967bcf73c13e9808"

  depends_on :xcode => "9.2"

  def install
    system("#{buildpath}/scripts/build #{buildpath} #{include}")
    build_data = File.readlines("#{buildpath}/build.data")
    binary_path = build_data.select { |f| f.include?("binary:") }.map { |f| f.gsub("binary: ", "").strip }.first
    libraries_paths = build_data.select { |f| f.include?("library:") }.map { |f| f.gsub("library: ", "").strip }
    bin.install binary_path
    libraries_paths.each do |library_path|
      include.install library_path
    end
  end

  test do
    system "#{bin}/sake", "init"
    system "#{bin}/sake", "tasks"
    system "#{bin}/sake", "task", "build"
  end
end
