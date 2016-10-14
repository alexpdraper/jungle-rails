class ReceiptMailer < ApplicationMailer

  def receipt_email(order)
    @order = order
    @order_url = order_url(@order.id)
    mail(to: @order.email, subject: "Jungle Order ##{@order.id}")
  end

end
