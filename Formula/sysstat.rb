class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/v12.2.0.tar.gz"
  sha256 "614ab9fe8e7937a3edb7b2b6760792a3764ea3a7310ac540292dd0e3dfac86a6"
  head "https://github.com/sysstat/sysstat.git"
  # tag "linux"

  bottle do
    sha256 "8748787763eb4a6601ef3ba439c9d33ddec179328afaf042e4369cbba8a5d39d" => :x86_64_linux
  end

  def install
    system "./configure",
      "--disable-file-attr", # Fix install: cannot change ownership
      "--prefix=#{prefix}",
      "conf_dir=#{etc}/sysconfig",
      "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    system "#{bin}/sar", "-V"
  end
end
