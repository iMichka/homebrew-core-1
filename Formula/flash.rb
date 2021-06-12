class Flash < Formula
  desc "Command-line script to flash SD card images of any kind"
  homepage "https://github.com/hypriot/flash"
  url "https://github.com/hypriot/flash/releases/download/2.7.2/flash"
  sha256 "571d9e6424b275859a9273029a2321245888ab201dbae1a3ec57a6ef708adce1"
  license "MIT"

  def install
    bin.install "flash"
  end

  test do
    cp test_fixtures("test.dmg.gz"), "test.dmg.gz"
    system "gunzip", "test.dmg"
    output = shell_output("echo foo | #{bin}/flash --device /dev/disk42 test.dmg", 1)
    assert_match "Please answer yes or no.", output
  end
end
