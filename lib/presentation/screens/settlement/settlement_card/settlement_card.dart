import 'package:flutter/material.dart';
import 'package:pndb_admin/data/models/settlement_model.dart';
import 'package:pndb_admin/presentation/screens/settlement/settlement_card/settlement_button/settlement_button.dart';
import 'package:pndb_admin/utils/constants.dart';

class SettlementCard extends StatefulWidget {
  final SettlementModel settlement;
  
  const SettlementCard({super.key, required this.settlement});
  
  @override
  _SettlementCardState createState() => _SettlementCardState();
}

class _SettlementCardState extends State<SettlementCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: pWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.shade200, width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.store, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Merchant",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.settlement.merchantId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.settlement.status == 'PENDING' ? "Amount to Settle" 
                    : widget.settlement.status == 'SETTLED' ? 'Amount settled'
                    : widget.settlement.status == 'FAILED' ? 'Amount settlement failed'
                    : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "₹${widget.settlement.amount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.settlement.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.settlement.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: _toggleExpanded,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.teal,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Expandable Details Section
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(
            children: [
              SizedBox(height: 5,),
              // Amount Breakdown Section // Settlement Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.blue.shade700, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          "Settlement Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow("Settlement ID", widget.settlement.settlementId, Icons.tag),
                    const SizedBox(height: 8),
                    _buildDetailRow("Date", widget.settlement.date, Icons.calendar_today),
                    const SizedBox(height: 19),
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.green.shade700, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          "Amount Breakdown",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildAmountRow("Total Amount", widget.settlement.totalAmount, false),
                    const SizedBox(height: 6),
                    _buildAmountRow("Merchant Fee", widget.settlement.merchantFee, true, isDeduction: true),
                    const SizedBox(height: 6),
                    _buildAmountRow("GST", widget.settlement.gst, true, isDeduction: true),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1.5),
                    const SizedBox(height: 8),
                    _buildAmountRow(widget.settlement.status == 'PENDING' ? "Amount to Settle" 
                    : widget.settlement.status == 'SETTLED' ? 'Amount settled'
                    : widget.settlement.status == 'FAILED' ? 'Amount settlement failed'
                    : '', widget.settlement.amount, false, isFinal: true),


                    // Action Button
                    if(widget.settlement.status == 'PENDING')
                    SettlementButton(settlementId: widget.settlement.settlementId,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Helper Methods
Widget _buildDetailRow(String label, String value, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey.shade600),
      const SizedBox(width: 8),
      Text(
        "$label: ",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );
}

Widget _buildAmountRow(String label, dynamic amount, bool isSmall, {bool isDeduction = false, bool isFinal = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: isSmall ? 13 : (isFinal ? 16 : 14),
          fontWeight: isFinal ? FontWeight.bold : FontWeight.w500,
          color: isDeduction ? Colors.red.shade700 : (isFinal ? Colors.green.shade800 : Colors.black87),
        ),
      ),
      Text(
        "${isDeduction ? '-' : ''}₹$amount",
        style: TextStyle(
          fontSize: isSmall ? 13 : (isFinal ? 18 : 14),
          fontWeight: isFinal ? FontWeight.bold : FontWeight.w600,
          color: isDeduction ? Colors.red.shade700 : (isFinal ? Colors.green.shade800 : Colors.black87),
        ),
      ),
    ],
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'completed':
      return Colors.green;
    case 'failed':
      return Colors.red;
    case 'processing':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}
}